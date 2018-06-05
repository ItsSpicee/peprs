#include "peprs.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    peprs w;
    w.show();

    return a.exec();
}
