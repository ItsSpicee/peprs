#include "dutsetup.h"
#include "ui_dutsetup.h"

DUTSetup::DUTSetup(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DUTSetup)
{
    ui->setupUi(this);
}

DUTSetup::~DUTSetup()
{
    delete ui;
}
