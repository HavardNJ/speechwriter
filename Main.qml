import QtQuick
import QtQuick.Window
import QtQuick.Controls


Window {
    id: window
    minimumWidth: 400
    minimumHeight: 600
    visible: true
    title: qsTr("Speechwriter")
    color: "#dbdbdb"

    Component {
        id: speechLineItemDelegate
        Item {
            id: speechLineItem
            width: speechView.width
            height: Math.max(textEdit.contentHeight, 30) + (model.paragraph ? 10 : 2)
            property bool paragraph: model.paragraph
            property bool duplicate: model.duplicate
            property string text: model.text

            Rectangle {
                id: background
                anchors.fill: parent
                anchors.topMargin: model.paragraph ? 10 : 2
                anchors.bottomMargin: 2
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                radius: 5
                color: model.duplicate ? "#fefee6" : "#fefefe"
                border.color: speechView.currentIndex === index ? "#5bb0c9" : null
                border.width: speechView.currentIndex === index ? 2 : 0
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        speechView.currentIndex = index;
                    }
                }
            }
            TextInput {
                id: textEdit
                anchors.fill: background
                verticalAlignment: TextEdit.AlignVCenter
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: model.text
                onTextEdited: {
                    speechModel.setText(index, textEdit.text)
                }
                onFocusChanged: {
                    if(focus){
                        speechView.currentIndex = index;
                    }
                }
            }
        }
    }

    ListView {
        id: speechView
        model: speechModel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: toolbar.top
        clip: true
        delegate: speechLineItemDelegate
        add: Transition {
                NumberAnimation { properties: "x,y"; from: 200; duration: 200 }
            }
        addDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }
    }
    
    Rectangle {
        id: addButton
        width: 40
        height: 40
        radius: 40
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        anchors.margins: 10
        color: "#a0ccd9"
        Image {
            width: 20
            height: 20
            anchors.centerIn: parent
            source: "qrc:/icons/icons/add_circle_outline_black_24dp.svg"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                speechModel.append();
                anim.start();
                speechView.currentIndex = speechModel.rowCount() -1;
            }
        }
        SequentialAnimation {
            id: anim
            NumberAnimation { target: addButton; property: "scale"; from: 1; to: 0.9; duration: 100 }
            NumberAnimation { target: addButton; property: "scale"; from: 0.9; to: 1; duration: 100 }
        }   
    }

    Toolbar {
        id: toolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        itemSelected: speechView.currentIndex > -1
        isCurrentParagraph: (speechView?.currentItem?.paragraph || false)
        isCurrentDuplicate: (speechView?.currentItem?.duplicate || false)

        onMoveUp:{
            if(speechView.currentIndex > 0){
                speechModel.swap(speechView.currentIndex - 1, speechView.currentIndex)
                speechView.currentIndex = speechView.currentIndex - 1;
            }
        }

        onMoveDown:{
            if(speechView.currentIndex < speechModel.rowCount() - 1){
                speechModel.swap(speechView.currentIndex, speechView.currentIndex + 1)
                speechView.currentIndex = speechView.currentIndex + 1;
            }
        }

        onToggleParagraph: {
            speechModel.setParagraph(speechView.currentIndex, !isCurrentParagraph);
        }

        onNextDuplicate: {
            const next = speechModel.findNextDuplicate(speechView.currentIndex, speechView.currentItem.text);
            speechView.currentIndex = next;
        }

        onDeleteCurrent: {
            speechModel.deleteLine(speechView.currentIndex)
            speechView.currentIndex = -1
        }
    }

    FileMenu {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 10
    }

    Shortcut {
        sequence: "F5"
        onActivated: {
            window.close()
            reloadhelper.loadQml()
        }
    }
}

