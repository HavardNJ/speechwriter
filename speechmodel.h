#ifndef SpeechMODEL_H
#define SpeechMODEL_H

#include <QAbstractListModel>

struct SpeechLine{
    QString text = "New line";
    bool paragraph = false;
};

class SpeechModel : public QAbstractListModel
{
    Q_OBJECT

private:
    QList<SpeechLine> mData;
    QMultiMap<QString, int> mDuplicatesMap;

public:
    enum modelRoles {
        textRole = Qt::UserRole + 100,
        paragraphRole,
        duplicateRole
    };

    SpeechModel(QObject *parent = nullptr);
    Q_INVOKABLE int rowCount(const QModelIndex& parent = QModelIndex()) const;
    int columnCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex());
    bool removeRow(int row, const QModelIndex &parent = QModelIndex());

    Q_INVOKABLE void append();
    Q_INVOKABLE void append(SpeechLine item);
    Q_INVOKABLE void setText(int index, QString text);
    Q_INVOKABLE void setParagraph(int row, bool paragraph);
    Q_INVOKABLE void swap(int a, int b);
    Q_INVOKABLE int findNextDuplicate(int fromRow, QString text);
    Q_INVOKABLE void deleteLine(int row);

    Q_INVOKABLE void load(QUrl fileName);
    Q_INVOKABLE void save(QUrl fileName);

signals:

private:
    bool isDuplicate(const QString &text) const;

};

#endif // SpeechMODEL_H
