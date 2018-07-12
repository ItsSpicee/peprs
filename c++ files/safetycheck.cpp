#include "safetycheck.h"
#include "ui_safetycheck.h"

safetycheck::safetycheck(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::safetycheck)
{
    ui->setupUi(this);
}

safetycheck::~safetycheck()
{
    delete ui;
}
