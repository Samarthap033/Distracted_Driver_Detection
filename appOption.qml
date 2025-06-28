import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.12

Rectangle {
    id: rectangle
    color: "#083142"
    width: 1600
    height: 900
    anchors.fill: parent

    Label {
        id: appName
        x: 445
        y: 59
        width: 778
        height: 62
        color: "#F9F871"
        text: qsTr("Distracted Driver Detection")
        anchors.horizontalCenter: parent.horizontalCenter
        font.weight: Font.Bold
        font.bold: true
        font.pointSize: 30
        font.family: "Verdana"
    }

    Rectangle {
        id: video
        y: 470
        width: 570
        height: 220
        color: "#96d777"
        radius: 20
        anchors.left: parent.left
        anchors.leftMargin: 130

        Label {
            id: videoLabel
            x: 234
            y: 102
            color: "#083142"
            text: qsTr("Video")
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 28
            font.bold: true
            font.family: "Verdana"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                video.color = "#00857D"
            }

            onReleased: {
                mainLoader.source = "appVideo.qml"
            }
        }
    }

    Rectangle {
        id: image
        x: 900
        y: 470
        width: 570
        height: 220
        color: "#96d777"
        radius: 20
        anchors.right: parent.right
        anchors.rightMargin: 130
        Label {
            id: imageLabel
            x: 234
            y: 102
            color: "#083142"
            text: qsTr("Image")
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            font.pointSize: 28
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Verdana"
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                image.color = "#00857D"
            }

            onReleased: {
                mainLoader.source = "appImage.qml"
            }
        }
    }

    Label {
        id: selectModeLabel
        x: 785
        y: 273
        width: 512
        height: 62
        color: "#ffffff"
        text: qsTr("Select Mode")
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        anchors.horizontalCenterOffset: 0
        font.pointSize: 32
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Verdana"
    }


}
