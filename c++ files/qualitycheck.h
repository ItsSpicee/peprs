#ifndef QUALITYCHECK_H
#define QUALITYCHECK_H

#include <QDialog>

namespace Ui {
class qualitycheck;
}

class qualitycheck : public QDialog
{
    Q_OBJECT

public:
    explicit qualitycheck(QWidget *parent = 0);
    ~qualitycheck();

private:
    Ui::qualitycheck *ui;
};

#endif // QUALITYCHECK_H
