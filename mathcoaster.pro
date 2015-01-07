TEMPLATE = subdirs
SUBDIRS = box2d game
CONFIG += ORDERED

game.depends = box2d
