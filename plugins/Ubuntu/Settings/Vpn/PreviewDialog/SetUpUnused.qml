/*
 * Copyright (C) 2016 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Lomiri.Components 1.3

Column {
    spacing: units.gu(2)
    objectName: "vpnPreviewSetUpUnused"

    Label {
        wrapMode: Text.WordWrap
        anchors { left: parent.left; right: parent.right; }
        text: i18n.dtr("ubuntu-settings-components", "This VPN is set up, but not in use now.")
    }

    Label {
        wrapMode: Text.WordWrap
        anchors { left: parent.left; right: parent.right; }
        text: i18n.dtr("ubuntu-settings-components", "When you use it:")
    }

    Label {
        wrapMode: Text.WordWrap
        anchors { left: parent.left; right: parent.right; }
        // TRANSLATORS: This describes the effect, should you enable the VPN.
        text: i18n.dtr("ubuntu-settings-components", "Your Wi-Fi/mobile provider can see when and how much you use the Internet, but not what for.")
    }

    Label {
        wrapMode: Text.WordWrap
        anchors { left: parent.left; right: parent.right; }
        // TRANSLATORS: This describes the effect, should you enable the VPN.
        text: i18n.dtr("ubuntu-settings-components", "The VPN provider can see or modify your Internet traffic.")
    }

    Label {
        wrapMode: Text.WordWrap
        anchors { left: parent.left; right: parent.right; }
        // TRANSLATORS: This describes the effect, should you enable the VPN.
        text: i18n.dtr("ubuntu-settings-components", "Web sites and other service providers can still monitor your use.")
    }
}
