#include "widget.h"


#define NODE_LAYER_0 784
#define NODE_LAYER_1 16
#define NODE_LAYER_2 10

#define BUFFER_SIZE 2352

float results[NODE_LAYER_2];
bool acc_flag = false;
int max_idx;
char img_str[20];

Widget::Widget(QWidget *parent) :
    QWidget(parent)
{
    setWindowTitle(tr("Painter"));
    this->setStyleSheet("background-color: grey");


    OK = new QPushButton(tr("init"),this);
    OK->setGeometry(Width*0.1, Height*0.87, 120, 50);
    OK->setText(tr("OK"));
    OK->setStyleSheet("QPushButton  {color: black;\
                      background-color: white;\
                      border-style: outset;\
                      border-width: 2px;\
                      border-color: beige;}");

    OK->setFont(QFont("consola", 20));
    QObject::connect(OK,SIGNAL(clicked()),this,SLOT(OK_clicked()));

    Clear = new QPushButton(tr("init"),this);
    Clear->setGeometry(Width*0.3, Height*0.87, 120, 50);
    Clear->setText(tr("Clear"));
    Clear->setStyleSheet("QPushButton  {color: red;\
                         background-color: white;\
                         border-style: outset;\
                         border-width: 2px;\
                         border-color: beige;}");

    Clear->setFont(QFont("consola", 20));
    QObject::connect(Clear,SIGNAL(clicked()),this,SLOT(Clear_clicked()));

    OCR = new QPushButton(tr("init"),this);
    OCR->setGeometry(Width*0.5, Height*0.87, 120, 50);
    OCR->setText(tr("OCR"));
    OCR->setStyleSheet("QPushButton  {color: green;\
                         background-color: white;\
                         border-style: outset;\
                         border-width: 2px;\
                         border-color: beige;}");

    OCR->setFont(QFont("consola", 20));
    QObject::connect(OCR,SIGNAL(clicked()),this,SLOT(OCR_clicked()));

}

void Widget::OK_clicked()
{
    QPixmap qpx;
    QImage img = qpx.grabWidget(this, 0, 0, Width*0.5, Width*0.5).scaled(28, 28, Qt::KeepAspectRatio, Qt::SmoothTransformation).toImage();
    QSize colImgSize = img.size();
    int width = colImgSize.rwidth();
    int height = colImgSize.rheight();
    unsigned char* colImgDataPtr = img.bits();
    QImage grayImg(colImgSize,QImage::Format_Indexed8);
    unsigned char* grayImgDataPtr = grayImg.bits();
    for(int i=0;i<height;i++)
        for(int j=0;j<width;j++)
        {
            *grayImgDataPtr = *(colImgDataPtr+1);
            colImgDataPtr += 4;
            grayImgDataPtr++;
        }
    QVector<QRgb> grayColTable;
    unsigned int rgb = 0;
    for(int i=0;i<256;i++)
    {
        grayColTable.append(rgb);
        rgb += 0x00010101;
    }
    grayImg.setColorTable(grayColTable);
    grayImg.save("saveImg.ppm","ppm");
    copy=1;
    update();
}


void Widget::Clear_clicked()
{
    _lines.clear();//clear all lines
    acc_flag=false;
    update();
    //qDebug()<<"Clear";
}

void Widget::OCR_clicked()
{
    qDebug() << "--------Start--------";

    acc_flag = accuracy();
    copy=1;

    update();
    qDebug() << "--------End--------";
}

void Widget::paintEvent(QPaintEvent *)
{
    int i=0;
    QPainter whiter(this);
    whiter.setPen(Qt::white);
    whiter.setBrush(Qt::white);
    whiter.drawRect(0, 0, Width*0.5, Width*0.5);// initialize Canvas
    whiter.drawRect(Width*0.5+5, 0, Width*0.5, Width*0.5);

    whiter.setPen(QColor("#E0DBD9"));
    whiter.drawRect(72, 72, 357, 357);


    QPainter path(this);
    QPen pen(Qt::black, 35, Qt::DashLine, Qt::RoundCap, Qt::RoundJoin);
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

    QPainter painter(this);
    painter.setPen(QPen(Qt::black,20));

    if(copy==1)
    {
        // use drawImage to draw copy
        painter.drawImage(Width*0.5+10,0,QImage("saveImg.ppm").\
                          scaled(Width*0.5-10, Width*0.5-10,\
                          Qt::KeepAspectRatio, Qt::SmoothTransformation));
        copy=0;
    }

    if(acc_flag == true)
    {
        for(i=0;i<10;i++)
        {
            qDebug()<<i<<":"<<results[i];
        }

        char i_str[2];
        char str[20];
        char res_str[20];
        for(int i=0 ; i<10 ;i++)
        {
            painter.setPen(Qt::NoPen);
            if(results[i]>0)
                painter.setBrush(QColor("#3498DB"));
            else
                painter.setBrush(QColor("#F39C12"));
            painter.drawRect(850+36*i, 550, 35, -(results[i]*5));
            snprintf(str,sizeof(str),"%.1f",results[i]);
            snprintf(i_str,sizeof(i_str),"%d",i);
            painter.setPen(QPen(Qt::black));
            painter.drawText(850+36*i+9, 550, 20, -10, Qt::AlignCenter, i_str);
        }
        //painter.drawLine(Width, 410, 750, 410);
        snprintf(res_str,sizeof(res_str),"%d",max_idx);
        painter.setFont(QFont("Arial",150));
        painter.drawText(Width, 100, 280, 280, Qt::AlignCenter, res_str);
        painter.setBrush(Qt::NoBrush);
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

    if(pos.x()<=Width/2-10 && pos.x()>5 && pos.y()<=Width/2-10)
    {
        erase=0;
        lastLine.append(pos);
    }
}

bool accuracy(){

    float w_h1[NODE_LAYER_1][NODE_LAYER_0];
    float w_o[NODE_LAYER_2][NODE_LAYER_1];
    float b_h1[NODE_LAYER_1];
    float b_o[NODE_LAYER_2];

    float v_h1[NODE_LAYER_1];

    int input[NODE_LAYER_0];
    float inputf[NODE_LAYER_0];
    FILE *fileprint;
    char filename[64];
    int i, j;

    float max;

    // training data //
    strcpy(filename, "merge.txt");

    fileprint = fopen(filename, "r");
    if (fileprint==NULL){
        puts("ERROR: read model.");
        exit(-1);
    }
    for (i=0;i<NODE_LAYER_1;i++)
        for (j=0;j<NODE_LAYER_0;j++)
            fscanf(fileprint, "%x", (unsigned int*)&w_h1[i][j]);

    for (i=0;i<NODE_LAYER_1;i++)
        fscanf(fileprint, "%x", (unsigned int*)&b_h1[i]);

    for (i=0;i<NODE_LAYER_2;i++)
        for (j=0;j<NODE_LAYER_1;j++)
            fscanf(fileprint, "%x", (unsigned int*)&w_o[i][j]);

    for (i=0;i<NODE_LAYER_2;i++)
        fscanf(fileprint, "%x", (unsigned int*)&b_o[i]);

    fclose(fileprint);

    // input data
    unsigned char buffer[BUFFER_SIZE];
    fileprint = fopen("saveImg.ppm", "r");
    //fileprint = fopen("00001.ppm", "r");

    if (fileprint==NULL){
        puts("err input");
        return 0;
    }

    fseek(fileprint, 14, SEEK_SET);//skip title(magic number etc.)//
    fread(buffer,1,BUFFER_SIZE,fileprint);

    for (i=0;i<NODE_LAYER_0;i++){
        input[i]=buffer[i*3];
        /*
        printf("%02d ",255-input[i]);
        if (i%28 == 27)
            printf("\n");
        */
    }
    printf("\n");
    fclose(fileprint);
    // Pixel format convertion. //
    for (i=0;i<NODE_LAYER_0;i++){
        input[i] = 255 - input[i];
        inputf[i] = ((float)input[i]) * (1.0/255.0);
    }

    // Calculate hidden layer 1. //
    for (i=0;i<NODE_LAYER_1;i++){
        v_h1[i] = 0.0;

        for (j=0;j<NODE_LAYER_0;j++){
            v_h1[i] += inputf[j]*w_h1[i][j];
        }

    }
    for (i=0;i<NODE_LAYER_1;i++){
        v_h1[i] += b_h1[i];
        if(v_h1[i]<0.0)	v_h1[i] = 0.0;
    }

    // Calculate output layer. //
    for (i=0;i<NODE_LAYER_2;i++){
        results[i] = 0.0;
        for (j=0;j<NODE_LAYER_1;j++)
            results[i] += v_h1[j]*w_o[i][j];
    }
    for (i=0;i<NODE_LAYER_2;i++)
        results[i] += b_o[i];

    for (i=0;i<10;i++)
        printf("results[%d]: %f\n", i , results[i]);
    printf("\n");

    // Find max value. //
    max = results[0];
    max_idx = 0;
    for (i=1;i<NODE_LAYER_2;i++)
        if(max<results[i]){
            max_idx = i;
            max = results[i];
        }
    printf("Final ans:%d\n",max_idx);//max_idx ?箸?��????	printf("--sw_end--\n");
    return true;
}
