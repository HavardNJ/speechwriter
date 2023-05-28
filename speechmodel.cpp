#include "speechmodel.h"

#include <QFile>
#include <QUrl>

SpeechModel::SpeechModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

int SpeechModel::rowCount(const QModelIndex &parent) const
{
    return mData.size();
}

int SpeechModel::columnCount(const QModelIndex &parent) const
{
    return 3;
}

QHash<int, QByteArray> SpeechModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames.insert(textRole, "text");
    roleNames.insert(paragraphRole, "paragraph");
    roleNames.insert(duplicateRole, "duplicate");
    return roleNames;
}

QVariant SpeechModel::data(const QModelIndex &index, int role) const
{
    if ( index.isValid())
    {
        switch(role){
        case textRole:
            return mData[index.row()].text;
        case paragraphRole:
            return mData[index.row()].paragraph;
        case duplicateRole:
            return isDuplicate(mData[index.row()].text);
        default:
            return QVariant();
        }
    }
    return QVariant();
}

bool SpeechModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if ( index.isValid())
    {
        switch(role){
        case textRole:
            mData[index.row()].text = value.toString();
            break;
        case paragraphRole:
            return mData[index.row()].paragraph = value.toBool();
            break;
        case duplicateRole:
        default:
            return false;
        }
        emit dataChanged(index, index);
        return true;
    }
    return false;
}

bool SpeechModel::insertRows(int row, int count, const QModelIndex &parent){
    beginInsertRows(QModelIndex(), row, row + count - 1);
    for(int i = 0; i < count; i++){
        SpeechLine item;
        mData.insert(row + i, item);
        mDuplicatesMap.insert(item.text.simplified(), row + i);
    }
    endInsertRows();
    return true;
}

bool SpeechModel::removeRow(int row, const QModelIndex &parent){
    if(row < 0 || row >= mData.size()) return false;
    beginRemoveRows(parent, row, row);
    mDuplicatesMap.clear();
    mData.removeAt(row);
    for(int i = 0; i < mData.size(); i++){
        mDuplicatesMap.insert(mData[i].text.simplified(), i);
    }
    endRemoveRows();
    emit dataChanged(index(0, 2), index (mData.size()-1, 2));
    return true;
}

void SpeechModel::append() {
    append(SpeechLine());
}

void SpeechModel::append(SpeechLine item) {
    const int i = mData.size();

    beginInsertRows(QModelIndex(), i, i);
    mData.append(item);
    mDuplicatesMap.insert(mData[i].text.simplified(), i);
    endInsertRows();

    emit dataChanged(index(0, 2), index (mData.size()-1, 2));
}

void SpeechModel::setText(int row, QString text) {
    mDuplicatesMap.remove(mData[row].text.simplified(), row);
    mData[row].text = text;
    mDuplicatesMap.insert(text.simplified(), row);

    emit dataChanged(index(0, 0), index (mData.size()-1, 2));
}

void SpeechModel::setParagraph(int row, bool paragraph) {
    mData[row].paragraph = paragraph;

    emit dataChanged(index(row, 0), index (row, 2));
}

void SpeechModel::swap(int a, int b) {
    const int i = mData.size();

    if(a < 0 || b < 0 || a >= i || b >= i)return;

    auto itemA = mData[a];
    auto itemB = mData[b];

    mDuplicatesMap.remove(itemA.text, a);
    mDuplicatesMap.remove(itemB.text, b);

    mDuplicatesMap.insert(itemB.text, a);
    mDuplicatesMap.insert(itemA.text, b);

    mData[a] = itemB;
    mData[b] = itemA;

    emit dataChanged(index(a, 0), index (b, 2));
}

int SpeechModel::findNextDuplicate(int fromRow, QString text) {
    auto rows = mDuplicatesMap.values(text.simplified());
    std::sort(rows.begin(), rows.end());
    const auto i = rows.indexOf(fromRow);
    if(i < rows.length() - 1){
        return rows[i+1];
    }
    return rows[0];
}

void SpeechModel::deleteLine(int row)
{
    removeRow(row);
}

void SpeechModel::load(QUrl fileName)
{
    beginRemoveRows(QModelIndex(), 0, mData.size()-1);
    mData.clear();
    endRemoveRows();

    QFile file(fileName.toLocalFile());
    file.open(QIODevice::ReadOnly);

    QTextStream reader(&file);
    bool nextIsParagraph = false;
    while(!reader.atEnd()){
        QString line = reader.readLine();
        if(line.isEmpty()){
            nextIsParagraph = true;
            continue;
        }
        SpeechLine item;
        item.text = line;
        item.paragraph = nextIsParagraph;
        append(item);
        nextIsParagraph = false;
    }
}

void SpeechModel::save(QUrl fileName)
{
    QFile file(fileName.toLocalFile());
    file.open(QIODevice::WriteOnly);

    QTextStream writer(&file);
    for(SpeechLine item : mData){
        if(item.paragraph){
            writer << "\n";
        }
        writer << item.text << "\n";
    }

}

bool SpeechModel::isDuplicate(const QString &text) const {
    return mDuplicatesMap.values(text.simplified()).size() > 1;
}

