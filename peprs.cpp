#include "peprs.h"
#include "ui_peprs.h"

peprs::peprs(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::peprs)
{
    ui->setupUi(this);
}

peprs::~peprs()
{
    delete ui;
}
