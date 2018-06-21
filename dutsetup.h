#ifndef DUTSETUP_H
#define DUTSETUP_H

#include <QWidget>

namespace Ui {
class DUTSetup;
}

class DUTSetup : public QWidget
{
    Q_OBJECT

public:
    explicit DUTSetup(QWidget *parent = 0);
    ~DUTSetup();

private:
    Ui::DUTSetup *ui;
};

#endif // DUTSETUP_H
