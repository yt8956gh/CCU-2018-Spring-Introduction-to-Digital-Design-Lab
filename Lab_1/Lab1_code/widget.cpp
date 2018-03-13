#include "widget.h"
#include <QPushButton>
#include <QPalette>
//#include <QDebug>
//#include <QSize>

Widget::Widget(QWidget *parent) :
    QWidget(parent)
{
    setWindowTitle(tr("Painter"));
    this->setStyleSheet("background-color: grey");


    OK = new QPushButton(tr("init"),this);
    OK->setGeometry(Width*0.60, Height*0.85, 120, 50);
    OK->setText(tr("OK"));
    OK->setStyleSheet("QPushButton  {color: black;\
                      background-color: white;\
                      border-style: outset;\
                      border-width: 2px;\
                      border-color: beige;}");

    OK->setFont(QFont("consola", 20));
    QObject::connect(OK,SIGNAL(clicked()),this,SLOT(OK_clicked()));

    Clear = new QPushButton(tr("init"),this);
    Clear->setGeometry(Width*0.25, Height*0.85, 120, 50);
    Clear->setText(tr("Clear"));
    Clear->setStyleSheet("QPushButton  {color: black;\
                         background-color: white;\
                         border-style: outset;\
                         border-width: 2px;\
                         border-color: beige;}");

    Clear->setFont(QFont("consola", 20));
    QObject::connect(Clear,SIGNAL(clicked()),this,SLOT(Clear_clicked()));

}

void Widget::OK_clicked()
{
    copy=1;//be condition of clear
    update();
    //qDebug()<<"OK";
}


void Widget::Clear_clicked()
{
    _lines.clear();//clear all lines
    update();
    //qDebug()<<"Clear";
}

void Widget::paintEvent(QPaintEvent *)
{
    int i=0;
    QPainter whiter(this);
    whiter.setPen(Qt::white);
    whiter.setBrush(Qt::white);
    whiter.drawRect(0, 0, Width*0.5-1, Height*0.76);// initialize Canvas
    whiter.drawRect(Width*0.5+1, 0, Width*0.5-1, Height*0.76);

    QPainter path(this);
    QPen pen(Qt::black, 20, Qt::DashLine, Qt::RoundCap, Qt::RoundJoin);
    path.setPen(pen);

    for(i=0; i<_lines.size(); i++)
    {
        const QVector<QPoint> &line = _lines.at(i);
        for(int j=0;j<line.size()-1;j++)
        {
            path.drawLine(line.at(j), line.at(j+1));
            //qDebug()<<line.at(j);
        }
    }

    if(copy==1)
    {
        for(i=0; i<_lines.size(); i++)
        {
            const QVector<QPoint> &line = _lines.at(i);
            for(int j=0;j<line.size()-1;j++)
            {

                QPoint start = line.at(j);
                QPoint end = line.at(j+1);
                //qDebug()<<line.at(j);
                start.setX(line.at(j).x()+Width/2);
                end.setX(line.at(j+1).x()+Width/2);

                //qDebug()<<start<<","<<end;
                path.drawLine(start, end);
            }
        }
        copy=0;
    }
}

void Widget::mouseMoveEvent(QMouseEvent *ev)
{

    if(_lines.size() == 0)
    {
        QVector<QPoint> line;
        _lines.append(line);
    }

    addLine(ev->pos());
    update();
}

void Widget::mousePressEvent(QMouseEvent *ev)
{
    QVector<QPoint> line;
    _lines.append(line);

    addLine(ev->pos());
}

void Widget::mouseReleaseEvent(QMouseEvent *ev)
{
    addLine(ev->pos());
}


void Widget::addLine(QPoint pos)
{
    QVector<QPoint> &lastLine = _lines.last();

    if(pos.x()<=Width/2-10 && pos.x()>5 && pos.y()<=Height*0.75)
    {
        erase=0;
        lastLine.append(pos);
    }
}
