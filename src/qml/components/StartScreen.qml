import QtQuick
import QtQuick.Controls.Basic
import Drift

Rectangle {
    id: root
    signal newProjectRequested()
    signal openProjectRequested()
    signal openRecentRequested(string path)
    color: Theme.appBackground
    readonly property var items: EditorState.recentProjects

    Flickable {
        id: page
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.height + 64
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: AppScrollBar { }
        Column {
            id: content
            width: Math.max(0, Math.min(1060, page.width - 48))
            anchors.horizontalCenter: parent.horizontalCenter
            y: 32
            spacing: 24
            Text {
                width: parent.width
                text: "Heinteira Frame"
                horizontalAlignment: Text.AlignHCenter
                font.family: Theme.fontFamily
                font.pixelSize: 30
                font.bold: true
                color: Theme.foreground
                style: Theme.glassMode ? Text.Raised : Text.Normal
                styleColor: Theme.darkMode ? "#80000000" : "#b0ffffff"
            }
            ThemedLabel {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                size: "base"
                text: qsTr("Suas ideias, seu próximo vídeo.")
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                ThemedButton {
                    text: qsTr("Novo projeto")
                    glyph: Theme.icons.plus
                    variant: "primary"
                    onClicked: root.newProjectRequested()
                }
                ThemedButton {
                    text: qsTr("Abrir projeto")
                    glyph: Theme.icons.folder
                    onClicked: root.openProjectRequested()
                }
            }
            ThemedLabel {
                width: parent.width
                text: qsTr("Projetos recentes")
                tone: "default"
                size: "base"
            }
            ThemedLabel {
                width: parent.width
                visible: root.items.length === 0
                text: qsTr("Os projetos que você salvar ou abrir aparecerão aqui.")
            }
            Grid {
                width: parent.width
                columns: Math.max(1, Math.floor((width + 16) / 236))
                spacing: 16
                Repeater {
                    model: root.items
                    delegate: Rectangle {
                        id: card
                        required property var modelData
                        readonly property bool available: modelData.exists !== false
                        width: Math.max(0, (parent.width - (parent.columns - 1) * parent.spacing) / parent.columns)
                        height: 208
                        radius: 12
                        color: hover.hovered ? Theme.panelAccent : Theme.panelBackground
                        border.color: Theme.panelBorder
                        border.width: 1
                        opacity: available ? 1 : 0.55
                        HoverHandler { id: hover }
                        Rectangle {
                            id: preview
                            x: 8; y: 8
                            width: parent.width - 16; height: 126
                            radius: 8
                            color: "#202b3b"
                            clip: true
                            Image {
                                id: thumbnail
                                anchors.fill: parent
                                source: card.modelData.thumbnail || ""
                                asynchronous: true
                                fillMode: Image.PreserveAspectFit
                            }
                            IconGlyph {
                                anchors.centerIn: parent
                                visible: thumbnail.status !== Image.Ready
                                glyph: Theme.icons.layers
                                iconSize: 36
                                iconColor: "#a7bdd5"
                            }
                        }
                        Text {
                            x: 12; y: 145
                            width: parent.width - 24
                            text: card.modelData.name
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSm
                            font.bold: true
                            color: Theme.foreground
                        }
                        Text {
                            x: 12; y: 172
                            width: parent.width - 24
                            text: !card.available ? qsTr("Arquivo movido ou excluído")
                                  : card.modelData.lastWorked
                                    ? Qt.formatDateTime(card.modelData.lastWorked, "dd/MM/yyyy HH:mm") : ""
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXs
                            color: Theme.mutedForeground
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: card.available ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                if (card.available) root.openRecentRequested(card.modelData.path)
                            }
                        }
                        ThemedToolTip {
                            visible: hover.hovered
                            text: card.modelData.path
                        }
                        IconButton {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 10
                            visible: hover.hovered
                            glyph: Theme.icons.x
                            tooltip: qsTr("Remover dos recentes")
                            onClicked: EditorState.removeRecentProject(card.modelData.path)
                        }
                    }
                }
            }
        }
    }
}
