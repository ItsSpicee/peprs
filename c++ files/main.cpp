#include "safetycheck.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    safetycheck w;
    w.show();

    return a.exec();
}
