/*
 * Filename:  pdfprovider.h
 * Project :  PdfView4Qt
 * Created by xuin on 06/04/2021.
 * Refer : https://github.com/bjhamltn/QPdf-Reader
 * Abstract : render pdf file for QtQuick by QQuickImageProvider
 */
#ifndef PDFPROVIDER_H
#define PDFPROVIDER_H

#include <QString>
#include <QImage>
#include <QUrlQuery>
#include <QPainter>
#include <QPen>
#include <QFutureWatcher>
#include <QtConcurrent>
#include <QObject>
#include <QQuickImageProvider>

#include <mupdf/fitz.h>
#include <mupdf/pdf.h>
#include <mupdf/fitz/util.h>
#include <mupdf/fitz/document.h>

class PdfProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(int pageCnt READ getPageCnt NOTIFY pageCntChanged)
    Q_PROPERTY(QString filePath READ getFilePath NOTIFY filePathChanged)

public:
    // 构造
    PdfProvider(QQuickImageProvider::ImageType type);

    // 加载文件
    Q_INVOKABLE void loadFile(const QString filePath, QVariant width,QVariant height, QVariant fitMode);

    // 丢弃文件
    Q_INVOKABLE void dropDoc();

private:
    QVariant pageInfo(int idx){
        return pageNumbers.at(idx);
    }

    enum FIT{
        Fit_Width,
        Fit_Height
    };

    bool isfitWidth();
    void preloadPages(const QString &id);
    void setNegMode(bool isNegative);
    void setFitToOption(int fit);
    void setDefaultwidth(int w);
    void setDefaultheight(int h);
    bool getNeg();
    int  getPageCnt();

    QString getFileName();
    QString getFilePath();

    QVariantList getpageNumbers();

    fz_buffer* writeSvg(  fz_context* ctx, fz_document* doc, int pageNbr,  fz_matrix ctm);

    QImage pagetoImage(int pageNbr, QString scale, int angle=0);
    QImage pagetoImage(fz_matrix ctm, fz_page *page);
    QImage requestImageFinal(const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    QImage requestImage_WithRectHighlights(const QString &id, QList<QPair<QString, QRect>> rects);

private:
    QMutex *mm;
    QMap<QString,QPixmap> imageIndex;
    QVariantList  pageNumbers;

    QString searchTerm;
    QString filename;
    QString filenamepath;

    int pagecnt;
    int defaultwidth;
    int defaultheight;

    float devicePixelRatio = 1;

    bool fileloaded;
    bool fitWidth;
    bool dropIMG;
    bool neg;
    bool smartCropping = false;

    fz_pixmap *fzimage;
    fz_context  *ctx;
    fz_document *doc;

signals:
    void pageCntChanged();
    void filePathChanged();
};
#endif
