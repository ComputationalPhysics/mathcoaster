/*
 * box2dbody.cpp
 * Copyright (c) 2010-2011 Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
 * Copyright (c) 2011 Daker Fernandes Pinheiro <daker.pinheiro@openbossa.org>
 * Copyright (c) 2011 Tan Miaoqing <miaoqing.tan@nokia.com>
 * Copyright (c) 2011 Antonio Aloisio <antonio.aloisio@nokia.com>
 * Copyright (c) 2011 Alessandro Portale <alessandro.portale@nokia.com>
 * Copyright (c) 2011 Joonas Erkinheimo <joonas.erkinheimo@nokia.com>
 * Copyright (c) 2011 Antti Krats <antti.krats@digia.com>
 *
 * This file is part of the Box2D QML plugin.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software in
 *    a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution.
 */

#include "box2dbody.h"

#include "box2dfixture.h"
#include "box2dworld.h"

static bool sync(float &value, float newValue)
{
    if (qFuzzyCompare(value, newValue))
        return false;

    value = newValue;
    return true;
}

static bool sync(b2Vec2 &value, const b2Vec2 &newValue)
{
    if (qFuzzyCompare(value.x, newValue.x) && qFuzzyCompare(value.y, newValue.y))
        return false;

    value = newValue;
    return true;
}


Box2DBody::Box2DBody(QObject *parent) :
    QObject(parent),
    mWorld(0),
    mTarget(0),
    mBody(0),
    mComponentComplete(false),
    mTransformDirty(false),
    mCreatePending(false)
{
    mBodyDef.userData = this;
}

Box2DBody::~Box2DBody()
{
    if (mBody)
        mWorld->world().DestroyBody(mBody);
}

void Box2DBody::setLinearDamping(float linearDamping)
{
    if (mBodyDef.linearDamping == linearDamping)
        return;

    mBodyDef.linearDamping = linearDamping;
    if (mBody)
        mBody->SetLinearDamping(linearDamping);

    emit linearDampingChanged();
}

void Box2DBody::setAngularDamping(float angularDamping)
{
    if (mBodyDef.angularDamping == angularDamping)
        return;

    mBodyDef.angularDamping = angularDamping;
    if (mBody)
        mBody->SetAngularDamping(angularDamping);

    emit angularDampingChanged();
}

void Box2DBody::setBodyType(BodyType bodyType)
{
    if (mBodyDef.type == static_cast<b2BodyType>(bodyType))
        return;

    mBodyDef.type = static_cast<b2BodyType>(bodyType);
    if (mBody)
        mBody->SetType(mBodyDef.type);

    emit bodyTypeChanged();
}

void Box2DBody::setBullet(bool bullet)
{
    if (mBodyDef.bullet == bullet)
        return;

    mBodyDef.bullet = bullet;
    if (mBody)
        mBody->SetBullet(bullet);

    emit bulletChanged();
}

void Box2DBody::setSleepingAllowed(bool sleepingAllowed)
{
    if (mBodyDef.allowSleep == sleepingAllowed)
        return;

    mBodyDef.allowSleep = sleepingAllowed;
    if (mBody)
        mBody->SetSleepingAllowed(sleepingAllowed);

    emit sleepingAllowedChanged();
}

void Box2DBody::setFixedRotation(bool fixedRotation)
{
    if (mBodyDef.fixedRotation == fixedRotation)
        return;

    mBodyDef.fixedRotation = fixedRotation;
    if (mBody)
        mBody->SetFixedRotation(fixedRotation);

    emit fixedRotationChanged();
}

void Box2DBody::setActive(bool active)
{
    if (mBodyDef.active == active)
        return;

    mBodyDef.active = active;
    if (mBody)
        mBody->SetActive(active);
}

bool Box2DBody::isAwake() const
{
    return mBody ? mBody->IsAwake() : mBodyDef.awake;
}

void Box2DBody::setAwake(bool awake)
{
    mBodyDef.awake = awake;
    if (mBody)
        mBody->SetAwake(awake);
}

QVector2D Box2DBody::linearVelocity() const
{
    if (mBody)
        return invertY(mBody->GetLinearVelocity());
    return invertY(mBodyDef.linearVelocity);
}

void Box2DBody::setLinearVelocity(const QVector2D &velocity)
{
    if (linearVelocity() == velocity)
        return;

    mBodyDef.linearVelocity = invertY(velocity);
    if (mBody)
        mBody->SetLinearVelocity(mBodyDef.linearVelocity);

    emit linearVelocityChanged();
}

float Box2DBody::angularVelocity() const
{
    if (mBody)
        return toDegrees(mBody->GetAngularVelocity());
    return toDegrees(mBodyDef.angularVelocity);
}

void Box2DBody::setAngularVelocity(float velocity)
{
    if (angularVelocity() == velocity)
        return;

    mBodyDef.angularVelocity = toRadians(velocity);
    if (mBody)
        mBody->SetAngularVelocity(mBodyDef.angularVelocity);

    emit angularVelocityChanged();
}

void Box2DBody::setGravityScale(float gravityScale)
{
    if (mBodyDef.gravityScale == gravityScale)
        return;

    mBodyDef.gravityScale = gravityScale;
    if (mBody)
        mBody->SetGravityScale(gravityScale);

    emit gravityScaleChanged();
}

QQmlListProperty<Box2DFixture> Box2DBody::fixtures()
{
    return QQmlListProperty<Box2DFixture>(this, 0,
                                          &Box2DBody::append_fixture,
                                          &Box2DBody::count_fixture,
                                          &Box2DBody::at_fixture,
                                          0);
}

void Box2DBody::append_fixture(QQmlListProperty<Box2DFixture> *list,
                               Box2DFixture *fixture)
{
    Box2DBody *body = static_cast<Box2DBody*>(list->object);
    body->mFixtures.append(fixture);
}

int Box2DBody::count_fixture(QQmlListProperty<Box2DFixture> *list)
{
    Box2DBody *body = static_cast<Box2DBody*>(list->object);
    return body->mFixtures.length();
}

Box2DFixture *Box2DBody::at_fixture(QQmlListProperty<Box2DFixture> *list, int index)
{
    Box2DBody *body = static_cast<Box2DBody*>(list->object);
    return body->mFixtures.at(index);
}

void Box2DBody::addFixture(Box2DFixture *fixture)
{
    mFixtures.append(fixture);
    if (mBody)
        fixture->initialize(this);
}

void Box2DBody::createBody()
{
    if (!mWorld)
        return;

    if (!mComponentComplete) {
        // When components are created dynamically, they get their parent
        // assigned before they have been completely initialized. In that case
        // we need to delay initialization.
        mCreatePending = true;
        return;
    }

    if (mTarget) {
        mBodyDef.position = mWorld->toMeters(QVector2D(mTarget->position()));
        mBodyDef.angle = toRadians(mTarget->rotation());
    }
    mBody = mWorld->world().CreateBody(&mBodyDef);
    mCreatePending = false;
    mTransformDirty = false;
    foreach (Box2DFixture *fixture, mFixtures)
        fixture->initialize(this);
    emit bodyCreated();
}

/**
 * Synchronizes the state of this body with the internal Box2D state.
 */
void Box2DBody::synchronize()
{
    Q_ASSERT(mBody);

    if (sync(mBodyDef.position, mBody->GetPosition())) {
        if (mTarget)
            mTarget->setPosition(mWorld->toPixels(mBodyDef.position).toPointF());
        emit positionChanged();
    }

    if (sync(mBodyDef.angle, mBody->GetAngle()))
        if (mTarget)
            mTarget->setRotation(toDegrees(mBodyDef.angle));
}

void Box2DBody::classBegin()
{
}

void Box2DBody::componentComplete()
{
    mComponentComplete = true;

    if (mCreatePending)
        createBody();
}

void Box2DBody::setWorld(Box2DWorld *world)
{
    if (mWorld == world)
        return;

    if (mWorld)
        disconnect(mWorld, SIGNAL(pixelsPerMeterChanged()), this, SLOT(onWorldPixelsPerMeterChanged()));
    if (world)
        connect(world, SIGNAL(pixelsPerMeterChanged()), this, SLOT(onWorldPixelsPerMeterChanged()));

    // Destroy body when leaving our previous world
    if (mWorld && mBody) {
        mWorld->world().DestroyBody(mBody);
        mBody = 0;
    }

    mWorld = world;
    createBody();
}

void Box2DBody::setTarget(QQuickItem *target)
{
    if (mTarget == target)
        return;

    if (mTarget)
        mTarget->disconnect(this);

    mTarget = target;
    mTransformDirty = target != 0;

    if (target) {
        connect(target, SIGNAL(xChanged()), this, SLOT(markTransformDirty()));
        connect(target, SIGNAL(yChanged()), this, SLOT(markTransformDirty()));
        connect(target, SIGNAL(rotationChanged()), this, SLOT(markTransformDirty()));
    }

    emit targetChanged();
}

void Box2DBody::updateTransform()
{
    Q_ASSERT(mTarget);
    Q_ASSERT(mBody);
    Q_ASSERT(mTransformDirty);

    mBodyDef.position = mWorld->toMeters(QVector2D(mTarget->position()));
    mBodyDef.angle = toRadians(mTarget->rotation());
    mBody->SetTransform(mBodyDef.position, mBodyDef.angle);
    mTransformDirty = false;
}

void Box2DBody::applyLinearImpulse(const QVector2D &impulse,
                                   const QVector2D &point)
{
    if (mBody)
        mBody->ApplyLinearImpulse(invertY(impulse), mWorld->toMeters(point), true);
}

void Box2DBody::applyAngularImpulse(qreal impulse)
{
    if (mBody)
        mBody->ApplyAngularImpulse(impulse, true);
}

void Box2DBody::applyTorque(qreal torque)
{
    if (mBody)
        mBody->ApplyTorque(torque, true);
}

QVector2D Box2DBody::getWorldCenter() const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetWorldCenter());
    return QVector2D();
}

QVector2D Box2DBody::getLocalCenter() const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetLocalCenter());
    return QVector2D();
}

void Box2DBody::applyForce(const QVector2D &force, const QVector2D &point)
{
    if (mBody)
        mBody->ApplyForce(invertY(force), mWorld->toMeters(point), true);
}

void Box2DBody::applyForceToCenter(const QVector2D &force)
{
    if (mBody)
        mBody->ApplyForceToCenter(invertY(force), true);
}

float Box2DBody::getMass() const
{
    return mBody ? mBody->GetMass() : 0.0;
}

void Box2DBody::resetMassData()
{
    if (mBody)
        mBody->ResetMassData();
}

float Box2DBody::getInertia() const
{
    return mBody ? mBody->GetInertia() : 0.0;
}

QVector2D Box2DBody::toWorldPoint(const QVector2D &localPoint) const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetWorldPoint(mWorld->toMeters(localPoint)));
    return QVector2D();
}

QVector2D Box2DBody::toWorldVector(const QVector2D &localVector) const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetWorldVector(mWorld->toMeters(localVector)));
    return QVector2D();
}

QVector2D Box2DBody::toLocalPoint(const QVector2D &worldPoint) const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetLocalPoint(mWorld->toMeters(worldPoint)));
    return QVector2D();
}

QVector2D Box2DBody::toLocalVector(const QVector2D &worldVector) const
{
    if (mBody)
        return mWorld->toPixels(mBody->GetLocalVector(mWorld->toMeters(worldVector)));
    return QVector2D();
}

QVector2D Box2DBody::getLinearVelocityFromWorldPoint(const QVector2D &point) const
{
    if (mBody)
        return invertY(mBody->GetLinearVelocityFromWorldPoint(mWorld->toMeters(point)));
    return QVector2D();
}

QVector2D Box2DBody::getLinearVelocityFromLocalPoint(const QVector2D &point) const
{
    if (mBody)
        return invertY(mBody->GetLinearVelocityFromLocalPoint(mWorld->toMeters(point)));
    return QVector2D();
}

void Box2DBody::markTransformDirty()
{
    mTransformDirty = mTransformDirty || (mWorld && !mWorld->isSynchronizing());
}

void Box2DBody::onWorldPixelsPerMeterChanged()
{
    if (mBody) {
        foreach (Box2DFixture *fixture, mFixtures)
            fixture->recreateFixture();
        markTransformDirty();
        updateTransform();
    }
}
