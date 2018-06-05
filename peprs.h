#ifndef PEPRS_H
#define PEPRS_H

#include <QMainWindow>

namespace Ui {
class peprs;
}

class peprs : public QMainWindow
{
    Q_OBJECT

public:
    explicit peprs(QWidget *parent = 0);
    ~peprs();

private:
    Ui::peprs *ui;
};

#endif // PEPRS_H
