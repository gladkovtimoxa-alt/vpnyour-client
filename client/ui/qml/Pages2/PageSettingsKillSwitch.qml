import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Config"

PageType {
    id: root

    BackButtonType {
        id: backButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20 + PageController.safeAreaTopMargin
    }

    FlickableType {
        id: fl
        anchors.top: backButton.bottom
        anchors.bottom: parent.bottom
        contentHeight: content.height

        ColumnLayout {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            HeaderTypeWithSwitcher {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                headerText: qsTr("KillSwitch")
                descriptionText: qsTr("Направляет сетевой трафик через защищённый туннель и предотвращает раскрытие IP-адреса и DNS-запросов при обрыве соединения")

                showSwitcher: true
                switcher {
                    checked: SettingsController.isKillSwitchEnabled
                    enabled: !ConnectionController.isConnected
                }
                switcherFunction: function(checked) {
                    if (!ConnectionController.isConnected) {
                        SettingsController.isKillSwitchEnabled = checked
                    } else {
                        PageController.showNotificationMessage(qsTr("KillSwitch settings cannot be changed during an active connection"))
                        switcher.checked = SettingsController.isKillSwitchEnabled
                    }
                }
            }

            VerticalRadioButton {
                id: softKillSwitch
                Layout.fillWidth: true
                Layout.topMargin: 32
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                enabled: SettingsController.isKillSwitchEnabled && !ConnectionController.isConnected
                checked: !SettingsController.strictKillSwitchEnabled

                text: qsTr("Soft KillSwitch")
                descriptionText: qsTr("Доступ в интернет блокируется при неожиданном обрыве защищённого соединения")

                onClicked: function() {
                    SettingsController.strictKillSwitchEnabled = false
                }

                Keys.onEnterPressed: this.clicked()
                Keys.onReturnPressed: this.clicked()
            }

            DividerType {}

            VerticalRadioButton {
                id: strictKillSwitch
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                visible: false
                enabled: false
                // enabled: SettingsController.isKillSwitchEnabled && !ConnectionController.isConnected
                checked: SettingsController.strictKillSwitchEnabled

                text: qsTr("Strict KillSwitch")
                descriptionText: qsTr("Интернет блокируется, даже если соединение отключено вручную или ещё не запущено")

                onClicked: function() {
                    var headerText = qsTr("Just a little heads-up")
                    var descriptionText = qsTr("Если при строгой блокировке соединение прервётся, доступ в интернет будет заблокирован. Для восстановления подключитесь снова либо отключите или измените KillSwitch.")
                    var yesButtonText = qsTr("Continue")
                    var noButtonText = qsTr("Cancel")

                    var yesButtonFunction = function() {
                        SettingsController.strictKillSwitchEnabled = true
                    }
                    var noButtonFunction = function() {
                    }

                    showQuestionDrawer(headerText, descriptionText, yesButtonText, noButtonText, yesButtonFunction, noButtonFunction)
                }

                Keys.onEnterPressed: this.clicked()
                Keys.onReturnPressed: this.clicked()
            }

            DividerType {
                visible: false
            }
            
            LabelWithButtonType {
                Layout.topMargin: 32
                Layout.fillWidth: true

                enabled: true
                text: qsTr("DNS Exceptions")
                descriptionText: qsTr("DNS servers listed here will remain accessible when KillSwitch is active.")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsKillSwitchExceptions)
                }
            }
        }
    }
} 
