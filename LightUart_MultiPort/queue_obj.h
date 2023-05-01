
/*
 *
 * Created by bill.zhang in 2023;
 *
 */

#ifndef __QUEUE_OBJ_H__
#define __QUEUE_OBJ_H__

typedef struct
{
  unsigned char lock;
  unsigned int queuesize;
  unsigned int head;
  unsigned int tail;
  char q[1024*10];

}QUEUE_OBJ_STRUCT;

class QUEUE_OBJ
{

private:
  QUEUE_OBJ_STRUCT *q;

public:
  QUEUE_OBJ();
  ~QUEUE_OBJ();

  void InitQueue();
  void EmptyQueue();
  void EnQueue(unsigned char data);
  char DeQueue();
  unsigned int IsQueueEmpty();
  unsigned int IsQueueFull();
  unsigned int QueueLength();
  unsigned int QueueState();

};



#endif


