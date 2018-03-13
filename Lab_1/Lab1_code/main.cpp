#include "widget.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    Widget w;
    w.resize(Width, Height);
    w.show();

    return app.exec();
 }
