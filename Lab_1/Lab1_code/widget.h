#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include<QPainter>
#include<QMouseEvent>
#include <QtWidgets/QPushButton>
#define Height 600
#define Width 1000

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);

    void paintEvent(QPaintEvent *ev);
    void mouseMoveEvent(QMouseEvent *ev);
    void mousePressEvent(QMouseEvent *ev);
    void mouseReleaseEvent(QMouseEvent *ev);
    void addLine(QPoint pos);

    QVector<QVector<QPoint> > _lines;

   private:
    QPushButton *OK;
    QPushButton *Clear;
    int erase,copy;
signals:

public slots:
    void Clear_clicked();
    void OK_clicked();
};

#endif 
