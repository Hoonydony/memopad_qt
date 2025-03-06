import QtQuick 2.15
import QtQuick.Controls 2.15
import Backend 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    title: "Look_at_me"

    Backend {
        id: backend
    }

    // Menu Bar
    MenuBar {
        Menu {
            title: "Look_at_me"

            MenuItem {
                text: "About Look_at_me"
                onTriggered: aboutDialog.open()
            }
        }
    }

    // About Dialog (without title)
    Dialog {
        id: aboutDialog
        title: ""

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 300
        height: 250

        contentItem: Item {
            anchors.fill: parent

            Column {
                spacing: 10
                anchors.centerIn: parent

                Image {
                    source: "qrc:/images/cake.png"
                    width: 100
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Look_at_me version 0.2 by hoonydony"
                    color: "gray"
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }
            }
        }

        standardButtons: Dialog.Ok
    }

    // Toolbar
    ToolBar {
        id: toolbar
        width: parent.width
        anchors.top: parent.top
        z: 1

        Row {
            anchors.fill: parent
            spacing: 5

            // Left-aligned buttons
            Row {
                id: leftRow
                spacing: 5
                ToolButton {
                    text: "Font Size"
                    onClicked: fontSizeDialog.open()
                }
                ToolButton {
                    text: "Bold"
                    onClicked: {
                        var tab = swipeView.currentItem
                        if (tab) {
                            backend.toggleBold(tab.textArea)
                        }
                    }
                }
                ToolButton {
                    text: "Underline"
                    onClicked: {
                        var tab = swipeView.currentItem
                        if (tab) {
                            backend.toggleUnderline(tab.textArea)
                        }
                    }
                }
            }

            // Spacer to push the next Row to the right
            Item {
                width: parent.width - leftRow.implicitWidth - rightRow.implicitWidth - parent.spacing * 2
                height: 1
            }

            // Right-aligned buttons
            Row {
                id: rightRow
                spacing: 5
                ToolButton {
                    text: "+"
                    onClicked: newTabDialog.open()
                }
                ToolButton {
                    text: "Save"
                    onClicked: {
                        var tab = swipeView.currentItem
                        if (tab) {
                            backend.saveFile(tab.textArea, swipeView.currentIndex)
                        } else {
                            console.log("Save: No current tab selected")
                        }
                    }
                }
                ToolButton {
                    text: "Copy All"
                    onClicked: {
                        var tab = swipeView.currentItem
                        if (tab) {
                            backend.copyAllText(tab.textArea)
                        } else {
                            console.log("Copy All: No current tab selected")
                        }
                    }
                }
            }
        }
    }

    // Tab Bar and Text Areas
    ListModel {
        id: tabModel
    }

    Column {
        anchors.top: toolbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        TabBar {
            id: tabBar
            width: parent.width

            Repeater {
                model: tabModel
                TabButton {
                    text: model.title
                    onDoubleClicked: {
                        renameTabDialog.tabIndex = index
                        renameTabDialog.originalTitle = model.title
                        renameTabDialog.open()
                    }

                    height: implicitHeight * 1.3

                    contentItem: Text {
                        text: parent.text
                        font.pointSize: 15
                        color: parent.checked ? "white" : "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.centerIn: parent
                    }
                }
            }
        }

        SwipeView {
            id: swipeView
            width: parent.width
            height: parent.height - tabBar.height
            currentIndex: tabBar.currentIndex
            clip: true

            Repeater {
                model: tabModel
                Item {
                    property alias textArea: textArea

                    ScrollView {
                        anchors.fill: parent
                        TextArea {
                            id: textArea
                            wrapMode: TextArea.Wrap
                            font.family: "Cambria Math"
                            font.pointSize: 25
                            selectByMouse: true
                            focus: swipeView.currentIndex === index

                            Keys.onPressed: (event) => {
                                console.log("TextArea: Key =", event.key, "Modifiers =", event.modifiers)
                                if (event.key === Qt.Key_B && (event.modifiers & Qt.ControlModifier)) {
                                    console.log("TextArea: Command+B detected, toggling bold")
                                    backend.toggleBold(textArea)
                                    event.accepted = true
                                }
                                if (event.key === Qt.Key_U && (event.modifiers & Qt.ControlModifier)) {
                                    console.log("TextArea: Command+U detected, toggling underline")
                                    backend.toggleUnderline(textArea)
                                    event.accepted = true
                                }
                            }

                            onActiveFocusChanged: {
                                console.log("TextArea focus changed:", activeFocus, "Tab index:", index)
                            }
                        }
                    }
                }
            }
        }
    }

    // Dialog for creating a new tab
    Dialog {
        id: newTabDialog
        title: "New Tab"
        standardButtons: Dialog.Ok | Dialog.Cancel

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        padding: 10

        Column {
            spacing: 10

            TextField {
                id: newTabTitleField
                placeholderText: "Enter tab title"
                width: 200
                focus: true

                Keys.onReturnPressed: {
                    if (newTabTitleField.text !== "") {
                        newTabDialog.accepted()
                        newTabDialog.close()
                    }
                }
            }
        }

        onAccepted: {
            if (newTabTitleField.text !== "") {
                tabModel.append({ "title": newTabTitleField.text })
                newTabTitleField.text = ""
                tabBar.currentIndex = tabModel.count - 1
            }
        }
    }

    // Dialog for renaming a tab
    Dialog {
        id: renameTabDialog
        title: "Rename Tab"
        standardButtons: Dialog.Ok | Dialog.Cancel

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        padding: 10

        Column {
            spacing: 10

            TextField {
                id: renameTabTitleField
                width: 200
                text: renameTabDialog.originalTitle
                focus: true

                Keys.onReturnPressed: {
                    if (renameTabTitleField.text !== "") {
                        renameTabDialog.accepted()
                        renameTabDialog.close()
                    }
                }
            }
        }

        onAccepted: {
            if (renameTabTitleField.text !== "" && tabIndex >= 0) {
                tabModel.setProperty(tabIndex, "title", renameTabTitleField.text)
            }
        }

        property int tabIndex: -1
        property string originalTitle: ""
    }

    // Dialog for changing font size
    Dialog {
        id: fontSizeDialog
        title: "Font Size"
        standardButtons: Dialog.Ok | Dialog.Cancel

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        padding: 10

        Column {
            spacing: 10

            TextField {
                id: fontSizeField
                placeholderText: "Enter new font size"
                width: 200
                validator: IntValidator { bottom: 1; top: 100 }
                focus: true

                Keys.onReturnPressed: {
                    if (fontSizeField.text !== "") {
                        fontSizeDialog.accepted()
                        fontSizeDialog.close()
                    }
                }
            }
        }

        onAccepted: {
            var tab = swipeView.currentItem
            if (tab && fontSizeField.text !== "") {
                backend.changeFontSize(tab.textArea, parseInt(fontSizeField.text))
            }
        }
    }

    Component.onCompleted: {
        newTabDialog.open()
    }
}
