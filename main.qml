import QtQuick 2.4
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 1600
    height: 900
    title: "Distracted Driver Detection"
    Material.theme: Material.Light
    Material.accent: Material.Teal

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: "appOption.qml"
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}D{i:3}D{i:2}
}
##^##*/
