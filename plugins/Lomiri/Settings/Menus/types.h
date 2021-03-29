/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef LOMIRISETTINGSMENUSTYPES_H
#define LOMIRISETTINGSMENUSTYPES_H

#include "pluginglobal.h"

#include <QObject>

class LOMIRISETTINGSCOMPONENTS_EXPORT TransferState : public QObject
{
    Q_OBJECT
    Q_ENUMS(TransferStates)
public:
    enum TransferStates {
        Queued,
        Running,
        Paused,
        Canceled,
        Hashing,
        Processing,
        Finished,
        Error
    };

    TransferState(QObject* parent = 0): QObject(parent) {}
};

#endif // LOMIRISETTINGSMENUSTYPES_H
