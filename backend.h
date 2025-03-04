#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QQuickTextDocument>
#include <QTextCursor>
#include <QTextDocument>
#include <QUrl>
#include <QFile>
#include <QTextStream>
#include <QClipboard>
#include <QGuiApplication>
#include <QtQuick>
#include <QFileDialog>

class Backend : public QObject {
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE void toggleBold(QQuickItem *textArea);
    Q_INVOKABLE void toggleUnderline(QQuickItem *textArea);
    Q_INVOKABLE void changeFontSize(QQuickItem *textArea, int newSize); // New method
    Q_INVOKABLE void saveFile(QQuickItem *textArea, int tabIndex);
    Q_INVOKABLE void saveToFile(const QString &text, const QString &filePath, int tabIndex);
    Q_INVOKABLE void copyAllText(QQuickItem *textArea);

private:
    QMap<int, QString> tabFileMapping; // Maps tab index to file path
};

#endif // BACKEND_H
