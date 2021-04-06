#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

#include "pdfprovider.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // qt quick pdf provider
    PdfProvider *pdfProvider  = new PdfProvider(QQuickImageProvider::Pixmap);
    engine.rootContext()->setContextProperty("PdfProvider", pdfProvider);
    engine.addImageProvider(QLatin1String("pdfpage"), pdfProvider);

    engine.rootContext()->setContextProperty("ApplicationPath", qApp->applicationDirPath());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
