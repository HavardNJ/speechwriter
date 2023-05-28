import QtQuick

import QtQuick.Dialogs

Item {
    id: fileMenu
    property bool expanded: false
    width: fileMenu.expanded ? 50 : 30
    height: fileMenu.expanded ? 90 : 30
    MouseArea{
        anchors.fill: parent
        onClicked: {
            fileMenu.expanded = !fileMenu.expanded;
        }
    }
    Rectangle{
        anchors.fill: parent
        clip: true
        radius: 5
        color: "#a0ccd9"

        Image{
            id: icon
            width: 20
            height: 20
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.topMargin: 5
            source: "qrc:/icons/icons/menu_black_24dp.svg"
        }
        Text {
            id: loadText
            anchors.left: parent.left
            anchors.top: icon.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 10
            text: qsTr("load")
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    fileMenu.expanded = false
                    loadDialog.visible = true
                }
            }
        }
        Text {
            anchors.left: parent.left
            anchors.top: loadText.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 10
            text: qsTr("save")
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    fileMenu.expanded = false
                    saveDialog.visible = true
                }
            }
        }
    }

    FileDialog {
        id: loadDialog
        title: "Please choose a file to load"
        defaultSuffix: "txt"
        fileMode: FileDialog.OpenFile
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            speechModel.load(selectedFile)
        }
    }

    FileDialog {
        id: saveDialog
        title: "Please choose a file to save"
        defaultSuffix: "txt"
        nameFilters: ["Text files (*.txt)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            speechModel.save(selectedFile)
        }
    }
}
