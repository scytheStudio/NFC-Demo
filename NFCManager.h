#ifndef NFCMANAGER_H
#define NFCMANAGER_H

#include <QObject>
#include <qqml.h>
#include <QtNfc/qnearfieldtarget.h>

class QNearFieldManager;
class QNdefMessage;
class QNdefNfcTextRecord;

struct Record {
    Q_GADGET
    Q_PROPERTY(int seconds MEMBER seconds)
    Q_PROPERTY(QString dishName MEMBER dishName)

public:
    int seconds = 0;
    QString dishName = "";

    bool parseNdefMessage(const QNdefNfcTextRecord &record);
    QNdefMessage generateNdefMessage() const;
};
Q_DECLARE_METATYPE(Record)

class NFCManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool hasTagInRange READ hasTagInRange NOTIFY hasTagInRangeChanged)
    Q_PROPERTY(ActionType actionType READ actionType WRITE setActionType NOTIFY actionTypeChanged)
    Q_PROPERTY(Record record READ record NOTIFY recordChanged)
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
    Record record() const;

public slots:
    void startReading();
    void stopDetecting();
    void saveRecord(const QString &dishName, int seconds);

signals:
    void hasTagInRangeChanged(bool hasTagInRange);
    void actionTypeChanged(ActionType actionType);
    void recordChanged(const Record &record);

    void wroteSuccessfully();
    void nfcError(const QString &error);

private slots:
    void setActionType(ActionType actionType);
    void setHasTagInRange(bool hasTagInRange);

    void onTargetDetected(QNearFieldTarget *target);
    void onTargetLost(QNearFieldTarget *target);

    void onNdefMessageRead(const QNdefMessage &message);
    void onNdefMessageWritten();
    void handleTargetError(QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &id);

private:
    bool m_hasTagInRange = false;
    ActionType m_actionType = ActionType::None;

    Record m_record;
    QNearFieldManager *m_manager;
    QNearFieldTarget::RequestId m_request;
};

#endif // NFCMANAGER_H
