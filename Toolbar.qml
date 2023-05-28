import QtQuick

Item {
    id: toolbar
    property bool itemSelected: false
    property bool isCurrentParagraph: false
    property bool isCurrentDuplicate: false
    height: 40
    property color buttonColor: '#a0ccd9'
    property color selectedButtonColor: '#5bb0c9'
    property color deativatedColor: '#acadad'

    signal moveUp()
    signal moveDown()
    signal toggleParagraph()
    signal nextDuplicate()
    signal deleteCurrent()

    Rectangle{
        anchors.fill: parent
    }

    Rectangle{
        id: moveUpButton
        radius: 5
        color: itemSelected ? buttonColor : deativatedColor
        width: 30
        height: 30
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        Image{
            anchors.centerIn: parent
            height: 20
            width: 20
            source: "qrc:/icons/icons/move_up_black_24dp.svg"
        }
        MouseArea{
            anchors.fill: parent
            enabled: itemSelected
            onClicked:{
                moveUp()
            }
        }
    }

    Rectangle{
        id: moveDownButton
        radius: 5
        color: itemSelected ? buttonColor : deativatedColor
        width: 30
        height: 30
        anchors.left: moveUpButton.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        Image{
            anchors.centerIn: parent
            height: 20
            width: 20
            source: "qrc:/icons/icons/move_down_black_24dp.svg"
        }
        MouseArea{
            anchors.fill: parent
            enabled: itemSelected
            onClicked:{
                moveDown();
            }
        }
    }

    Rectangle{
        id: paragraphButton
        radius: 5
        color: itemSelected ? (isCurrentParagraph ? selectedButtonColor : buttonColor) : deativatedColor
        width: 30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        Image{
            anchors.centerIn: parent
            height: 20
            width: 20
            source: "qrc:/icons/icons/splitscreen_black_24dp.svg"
        }
        MouseArea{
            anchors.fill: parent
            enabled: itemSelected
            onClicked:{
                toggleParagraph();
            }
        }
    }

    Rectangle{
        id: nextDuplicateButton
        radius: 5
        color: itemSelected && isCurrentDuplicate ? buttonColor : deativatedColor
        width: 30
        height: 30
        anchors.right: deleteButton.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        Image{
            anchors.centerIn: parent
            height: 20
            width: 20
            source: "qrc:/icons/icons/content_copy_black_24dp.svg"
        }
        MouseArea{
            enabled: isCurrentDuplicate
            anchors.fill: parent
            onClicked:{
                nextDuplicate();
            }
        }
    }

    Rectangle{
        id: deleteButton
        radius: 5
        color: itemSelected ? buttonColor : deativatedColor
        width: 30
        height: 30
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        Image{
            anchors.centerIn: parent
            height: 20
            width: 20
            source: "qrc:/icons/icons/delete_outline_black_24dp.svg"
        }
        MouseArea{
            enabled: itemSelected
            anchors.fill: parent
            onClicked:{
                deleteCurrent();
            }
        }
    }

}
