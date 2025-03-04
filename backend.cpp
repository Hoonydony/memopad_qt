#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent) {}

void Backend::toggleBold(QQuickItem *textArea) {
    if (!textArea) {
        qWarning() << "toggleBold: textArea is null";
        return;
    }

    QQuickTextDocument *doc = textArea->property("textDocument").value<QQuickTextDocument*>();
    if (!doc) {
        qWarning() << "toggleBold: textDocument is null";
        return;
    }

    QTextDocument *textDoc = doc->textDocument();
    QTextCursor cursor(textDoc);
    QVariant selectionStart = textArea->property("selectionStart");
    QVariant selectionEnd = textArea->property("selectionEnd");

    if (!selectionStart.isValid() || !selectionEnd.isValid()) {
        qWarning() << "toggleBold: selectionStart or selectionEnd is invalid";
        return;
    }

    int start = selectionStart.toInt();
    int end = selectionEnd.toInt();
    if (start == end) {
        qWarning() << "toggleBold: No text selected (start == end)";
        return;
    }

    cursor.setPosition(start);
    cursor.setPosition(end, QTextCursor::KeepAnchor);

    QTextCharFormat format = cursor.charFormat();
    bool isBold = format.fontWeight() == QFont::Bold;
    format.setFontWeight(isBold ? QFont::Normal : QFont::Bold);
    cursor.mergeCharFormat(format);
}

void Backend::toggleUnderline(QQuickItem *textArea) {
    if (!textArea) {
        qWarning() << "toggleUnderline: textArea is null";
        return;
    }

    QQuickTextDocument *doc = textArea->property("textDocument").value<QQuickTextDocument*>();
    if (!doc) {
        qWarning() << "toggleUnderline: textDocument is null";
        return;
    }

    QTextDocument *textDoc = doc->textDocument();
    QTextCursor cursor(textDoc);
    QVariant selectionStart = textArea->property("selectionStart");
    QVariant selectionEnd = textArea->property("selectionEnd");

    if (!selectionStart.isValid() || !selectionEnd.isValid()) {
        qWarning() << "toggleUnderline: selectionStart or selectionEnd is invalid";
        return;
    }

    int start = selectionStart.toInt();
    int end = selectionEnd.toInt();
    if (start == end) {
        qWarning() << "toggleUnderline: No text selected (start == end)";
        return;
    }

    cursor.setPosition(start);
    cursor.setPosition(end, QTextCursor::KeepAnchor);

    QTextCharFormat format = cursor.charFormat();
    bool isUnderlined = format.fontUnderline();
    format.setFontUnderline(!isUnderlined);
    cursor.mergeCharFormat(format);
}

void Backend::changeFontSize(QQuickItem *textArea, int newSize) {
    if (!textArea) {
        qWarning() << "changeFontSize: textArea is null";
        return;
    }

    QQuickTextDocument *doc = textArea->property("textDocument").value<QQuickTextDocument*>();
    if (!doc) {
        qWarning() << "changeFontSize: textDocument is null";
        return;
    }

    QTextDocument *textDoc = doc->textDocument();
    QTextCursor cursor(textDoc);
    QVariant selectionStart = textArea->property("selectionStart");
    QVariant selectionEnd = textArea->property("selectionEnd");

    if (!selectionStart.isValid() || !selectionEnd.isValid()) {
        qWarning() << "changeFontSize: selectionStart or selectionEnd is invalid";
        return;
    }

    int start = selectionStart.toInt();
    int end = selectionEnd.toInt();
    if (start == end) {
        qWarning() << "changeFontSize: No text selected (start == end)";
        return;
    }

    cursor.setPosition(start);
    cursor.setPosition(end, QTextCursor::KeepAnchor);

    QTextCharFormat format = cursor.charFormat();
    format.setFontPointSize(newSize);
    cursor.mergeCharFormat(format);
}

void Backend::saveFile(QQuickItem *textArea, int tabIndex) {
    if (!textArea) {
        qWarning() << "saveFile: textArea is null";
        return;
    }

    QString content = textArea->property("text").toString();
    if (content.isEmpty()) {
        qWarning() << "saveFile: No content to save for tab index" << tabIndex;
        return;
    }

    qDebug() << "saveFile: Tab index" << tabIndex << "Content length:" << content.length() << "Content:" << content;

    if (tabFileMapping.contains(tabIndex)) {
        qDebug() << "saveFile: Saving to existing file:" << tabFileMapping[tabIndex];
        saveToFile(content, tabFileMapping[tabIndex], tabIndex);
    } else {
        qDebug() << "saveFile: Opening file dialog for new file";
        try {
            QString defaultFileName = "untitled.txt";
            QString filePath = QFileDialog::getSaveFileName(nullptr,
                                                            "Save File",
                                                            defaultFileName,
                                                            "Text files (*.txt);;All files (*.*)");
            if (!filePath.isEmpty()) {
                qDebug() << "saveFile: Selected file path:" << filePath;
                saveToFile(content, filePath, tabIndex);
            } else {
                qDebug() << "saveFile: No file selected, canceling save";
            }
        } catch (const std::exception &e) {
            qWarning() << "saveFile: Exception caught during file dialog:" << e.what();
        } catch (...) {
            qWarning() << "saveFile: Unknown exception caught during file dialog";
        }
    }
}

void Backend::saveToFile(const QString &text, const QString &filePath, int tabIndex) {
    qDebug() << "saveToFile: Attempting to save to" << filePath;

    try {
        QFile file(filePath);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qWarning() << "saveToFile: Failed to open file:" << filePath << "Error:" << file.errorString();
            return;
        }

        QTextStream out(&file);
        out << text;
        file.close();

        qDebug() << "saveToFile: Successfully saved to" << filePath;
        tabFileMapping[tabIndex] = filePath;
    } catch (const std::exception &e) {
        qWarning() << "saveToFile: Exception caught during file writing:" << e.what();
    } catch (...) {
        qWarning() << "saveToFile: Unknown exception caught during file writing";
    }
}

void Backend::copyAllText(QQuickItem *textArea) {
    if (!textArea) {
        qWarning() << "copyAllText: textArea is null";
        return;
    }

    QString text = textArea->property("text").toString();
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(text);
    qDebug() << "copyAllText: Copied text to clipboard, length:" << text.length();
}
