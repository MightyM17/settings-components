/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by Andrea Cimitan <andrea.cimitan@canonical.com>
 */

import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Components 0.1
import Ubuntu.SettingsComponents 0.1
import "utils.js" as UtilsJS

Item {
    width: units.gu(42)
    height: units.gu(75)

    Flickable {
        id: flickable

        anchors.fill: parent
        contentWidth: column.width
        contentHeight: column.height

        Column {
            id: column

            width: flickable.width
            height: childrenRect.height

            ButtonMenu {
                id: buttonMenu
                text: i18n.tr("Button")
                buttonText: i18n.tr("Hello world!")
            }
        }
    }

    SignalSpy {
        id: signalSpy
        signalName: "clicked"
        target: buttonMenu
    }

    TestCase {
        name: "ButtonMenu"
        when: windowShown

        function test_click() {
            signalSpy.clear()

            var button = UtilsJS.findChild(buttonMenu, "button")
            mouseClick(buttonMenu, button.width / 2, button.height / 2, Qt.LeftButton, Qt.NoModifier, 0)
            compare(signalSpy.count > 0, true, "signal clicked not triggered")
        }
    }
}
