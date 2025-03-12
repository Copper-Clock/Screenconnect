#include <QApplication>
#include <QDebug>
#include <QtDBus>
#include <QWebEngineView>

#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QCursor cursor(Qt::BlankCursor);
    QApplication::setOverrideCursor(cursor);
    QApplication::changeOverrideCursor(cursor);

    MainWindow *window = new MainWindow();
    window -> show();

    QDBusConnection connection = QDBusConnection::sessionBus();

    if (!connection.registerObject("/Copper-Clock", window,  QDBusConnection::ExportAllSlots))
    {
        qWarning() << "Can't register object";
        return 1;
    }
    qDebug() << "WebView connected to D-bus";

    if (!connection.registerService("tccconnect.webview")) {
        qWarning() << qPrintable(QDBusConnection::sessionBus().lastError().message());
        return 1;
    }
    qDebug() << "Copper-Clock service start";


    return app.exec();
}
