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
 */

import QtQuick 2.0
import Ubuntu.Components 0.1
import "dateExt.js" as DateExt

ListView {
    id: monthView

    property bool collapsed: false
    property var currentDate: selectedDate.monthStart().addDays(15)
    property var firstDayOfWeek: Qt.locale(i18n.language).firstDayOfWeek
    property var maximumDate
    property var minimumDate
    property var selectedDate: priv.today

    Component.onCompleted: {
        priv.__populateModel()
        timer.start()
    }

    onCurrentIndexChanged: {
        if (!priv.ready) return

        var currentMonth = currentItem.monthStart
        var minimumMonth = calendarModel.get(0).monthStart
        var maximumMonth = calendarModel.get(calendarModel.count - 1).monthStart
        if (DateExt.diffMonths(minimumMonth, currentMonth) <= 1) {
            var newDate = minimumMonth.addMonths(-1)
            if (priv.__withinLowerMonthBound(newDate)) {
                calendarModel.insert(0, {"monthStart": newDate})
                if (calendarModel.count > 5) calendarModel.remove(calendarModel.count - 1)
            }
        } else if (DateExt.diffMonths(currentMonth, maximumMonth) <= 1) {
            var newDate = maximumMonth.addMonths(1)
            if (priv.__withinUpperMonthBound(newDate)) {
                calendarModel.append({"monthStart": newDate})
                if (calendarModel.count > 5) calendarModel.remove(0)
            }
        }

        currentDate = currentItem.monthStart
    }

    onCurrentDateChanged: {
        if (!priv.ready) return

        if (currentDate.monthStart().getTime() != currentItem.monthStart.getTime()) {
            for (var i = 0; i < calendarModel.count; i++) {
                if (calendarModel.get(i).monthStart.getTime() == currentDate.monthStart().getTime()) {
                    currentIndex = i
                    return
                }
            }

            calendarModel.clear()
            priv.__populateModel()
        }
    }

    onMaximumDateChanged: {
        if (!priv.ready) return

        var i = calendarModel.count - 1
        while (i >= 0 && calendarModel.get(i).monthStart > maximumDate) {
            calendarModel.remove(i)
            i--
        }

        if (calendarModel.count == 0) {
            priv.__populateModel()
        }
    }

    onMinimumDateChanged: {
        if (!priv.ready) return

        var i = 0
        while (i < calendarModel.count && calendarModel.get(0).monthStart < minimumDate) {
            calendarModel.remove(0)
            i++
        }

        if (calendarModel.count == 0) {
            priv.__populateModel()
        }
    }

    ListModel {
        id: calendarModel
    }

    QtObject {
        id: priv

        property bool ready: false
        property int squareUnit: monthView.width / 7
        property int verticalMargin: units.gu(1)
        property var today: (new Date()).midnight()

        function __withinLowerMonthBound(date) {
            return minimumDate == undefined || date.monthStart() >= minimumDate.monthStart()
        }

        function __withinUpperMonthBound(date) {
            return maximumDate == undefined || date.monthStart() <= maximumDate.monthStart()
        }

        function __getRealMinimumDate(date) {
            if (minimumDate != undefined && minimumDate > date) {
                return minimumDate;
            }
            return date;
        }

        function __getRealMaximumDate(date) {
            if (maximumDate != undefined && maximumDate < date) {
                return maximumDate;
            }
            return date;
        }

        function __populateModel() {
            //  disable the onCurrentIndexChanged logic
            priv.ready = false

            var minimumAddedDate = priv.__getRealMinimumDate(currentDate.addMonths(-2));
            var maximumAddedDate = priv.__getRealMaximumDate(currentDate.addMonths(2));

            var count = Math.min(DateExt.diffMonths(minimumAddedDate, maximumAddedDate) + 1, 5)
            for (var i = 0; i < count; ++i) {
                calendarModel.append({"monthStart": minimumAddedDate.monthStart().addMonths(i)});
            }

            currentIndex = DateExt.diffMonths(minimumAddedDate, currentDate);

            // Ok, we're all set up. enable the onCurrentIndexChanged logic
            priv.ready = true
        }
    }

    Timer {
        id: timer
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: priv.today = (new Date()).midnight()
    }

    width: parent.width
    height: priv.squareUnit * (collapsed ? 1 : 6) + priv.verticalMargin * 2
    interactive: !collapsed
    clip: true
    cacheBuffer: width + 1
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: 0
    preferredHighlightEnd: width
    model: calendarModel
    orientation: ListView.Horizontal
    snapMode: ListView.SnapOneItem
    focus: true

    Keys.onLeftPressed: selectedDate.addDays(-1)
    Keys.onRightPressed: selectedDate.addDays(1)

    delegate: Item {
        id: monthItem

        property int currentWeekRow: Math.floor((selectedDate.getTime() - gridStart.getTime()) / Date.msPerWeek)
        property var gridStart: monthStart.weekStart(firstDayOfWeek)
        property var monthEnd: monthStart.addMonths(1)
        property var monthStart: model.monthStart

        width: monthView.width
        height: monthView.height

        Grid {
            id: monthGrid

            rows: 6
            columns: 7
            y: priv.verticalMargin
            width: priv.squareUnit * columns
            height: priv.squareUnit * rows

            Repeater {
                model: monthGrid.rows * monthGrid.columns
                delegate: Item {
                    id: dayItem
                    objectName: "dayItem" + index

                    property bool isCurrent: (dayStart.getFullYear() == selectedDate.getFullYear() &&
                                              dayStart.getMonth() == selectedDate.getMonth() &&
                                              dayStart.getDate() == selectedDate.getDate())
                    property bool isCurrentMonth: monthStart <= dayStart && dayStart < monthEnd
                    property bool isCurrentWeek: row == currentWeekRow
                    property bool isSunday: weekday == 0
                    property bool isToday: dayStart.getTime() == priv.today.getTime()
                    property bool isWithinBounds: (minimumDate == undefined || dayStart >= minimumDate) &&
                                                  (maximumDate == undefined || dayStart <= maximumDate)
                    property int row: Math.floor(index / 7)
                    property int weekday: (index % 7 + firstDayOfWeek) % 7
                    property real bottomMargin: (row == 5 || (collapsed && isCurrentWeek)) ? -priv.verticalMargin : 0
                    property real topMargin: (row == 0 || (collapsed && isCurrentWeek)) ? -priv.verticalMargin : 0
                    property var dayStart: gridStart.addDays(index)

                    // Styling properties
                    property color color: "#757373"
                    property color todayColor: "#DD4814"
                    property string fontSize: "large"
                    property var backgroundColor: "transparent" // FIXME use color instead var when Qt will fix the bug with the binding (loses alpha)
                    property var sundayBackgroundColor: "#19AEA79F" // FIXME use color instead var when Qt will fix the bug with the binding (loses alpha)

                    visible: collapsed ? isCurrentWeek : true
                    width: priv.squareUnit
                    height: priv.squareUnit

//                    ItemStyle.class: "day"
                    Item {
                        anchors {
                            fill: parent
                            topMargin: dayItem.topMargin
                            bottomMargin: dayItem.bottomMargin
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: color.a > 0
                            color: isSunday ? dayItem.sundayBackgroundColor : dayItem.backgroundColor
                        }

                        Label {
                            anchors.centerIn: parent
                            text: dayStart.getDate()
                            fontSize: dayItem.fontSize
                            color: isToday ? dayItem.todayColor : dayItem.color
                            scale: isCurrent ? 1.8 : 1.
                            opacity: isWithinBounds ? isCurrentMonth ? 1. : 0.3 : 0.1

                            Behavior on scale {
                                NumberAnimation { duration: 50 }
                            }
                        }
                    }

                    MouseArea {
                        anchors {
                            fill: parent
                            topMargin: dayItem.topMargin
                            bottomMargin: dayItem.bottomMargin
                        }

                        onReleased: if (isWithinBounds) monthView.selectedDate = dayStart
                    }
                }
            }
        }
    }
}