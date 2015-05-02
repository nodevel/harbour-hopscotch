import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: xmlModel
    property int newItems: 0
    onXmlChanged: {
        console.log("XML CHANGED")
    }

    query: listModel.query
    onStatusChanged: {
        if (xml) {
            if (status == XmlListModel.Loading) {
                loading = true
            } else if (status === XmlListModel.Ready) {
                if (count > 0) {
                    newItems++
                    console.log(xmlModel.get(2).name)
                    console.log(query)
                    for (var i = 0; i < xmlModel.count; i++) {
                        listModel.append(xmlModel.get(i))
//                        if (i < 8) {
//                            coverModel.set(i, xmlModel.get(i))
//                        }
                    }
                }

                loading = false
            }
            else {
                loading = false
            }
        }
    }
    property string searchString: ''
    XmlRole { name: "Id"; query: "@id/string()" }
    XmlRole { name: "rating"; query: "@rating/string()" }
    XmlRole { name: "name"; query: "@name/string()" }
    XmlRole { name: "author"; query: "@maker/string()" }
    XmlRole { name: "cover"; query: "@cover/string()" }
    XmlRole { name: "price"; query: "@price/string()" }

}
