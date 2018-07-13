#include "qualitycheck.h"
#include "ui_qualitycheck.h"

qualitycheck::qualitycheck(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::qualitycheck)
{
    ui->setupUi(this);
}

qualitycheck::~qualitycheck()
{
    delete ui;
}
