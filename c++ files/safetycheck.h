#ifndef SAFETYCHECK_H
#define SAFETYCHECK_H

#include <QDialog>

namespace Ui {
class safetycheck;
}

class safetycheck : public QDialog
{
    Q_OBJECT

public:
    explicit safetycheck(QWidget *parent = 0);
    ~safetycheck();

private:
    Ui::safetycheck *ui;
};

#endif // SAFETYCHECK_H
