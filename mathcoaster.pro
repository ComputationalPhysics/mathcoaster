TEMPLATE = subdirs
SUBDIRS = box2d game
CONFIG += ordered

game.depends = box2d
