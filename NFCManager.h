#ifndef NFCMANAGER_H
#define NFCMANAGER_H

#include <QObject>
#include <qqml.h>
#include <QtNfc/qnearfieldtarget.h>

class QNearFieldManager;
class QNdefMessage;
class QNdefNfcTextRecord;

struct Record {
    int seconds = 0;
    QString dishName = "";

    bool parseNdefMessage(const QNdefNfcTextRecord &record);
    QNdefMessage generateNdefMessage() const;
};

class NFCManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool hasTagInRange READ hasTagInRange NOTIFY hasTagInRangeChanged)
    Q_PROPERTY(ActionType actionType READ actionType WRITE setActionType NOTIFY actionTypeChanged)
    QML_ELEMENT

public:
    explicit NFCManager(QObject *parent = nullptr);

    enum ActionType
    {
        None = 0,
        Reading,
        Writing
    };
    Q_ENUM(ActionType)

    bool hasTagInRange() const;
    ActionType actionType() const;

public slots:
    void startReading();
    void stopDetecting();
    void saveRecord(const QString &dishName, int seconds);

signals:
    void hasTagInRangeChanged(bool hasTagInRange);
    void actionTypeChanged(ActionType actionType);
    void tagFound(const QString &dishName, int seconds);

    void wroteSuccessfully();

    void nfcError(const QString &error);

private slots:
    void setActionType(ActionType actionType);
    void setHasTagInRange(bool hasTagInRange);

    void targetDetected(QNearFieldTarget *target);
    void targetLost(QNearFieldTarget *target);

    void ndefMessageRead(const QNdefMessage &message);
    void ndefMessageWritten();
    void targetError(QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &id);

private:
    bool m_hasTagInRange = false;
    ActionType m_actionType = ActionType::None;

    Record m_record;
    QNearFieldManager *m_manager;
    QNearFieldTarget::RequestId m_request;
};

#endif // NFCMANAGER_H
