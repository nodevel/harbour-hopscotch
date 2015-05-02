#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>

#include <sailfishapp.h>


int main(int argc, char *argv[])
{
//    QCoreApplication::setOrganizationName("nodevel.net");
//    QCoreApplication::setOrganizationDomain("nodevel.net");
//    QCoreApplication::setApplicationName("Hopscotch");

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    view->rootContext()->setContextProperty("inputUrl", argv[1]);

    view->setSource(SailfishApp::pathTo("qml/harbour-hopscotch.qml"));

    view->show();

    return app->exec();
}

