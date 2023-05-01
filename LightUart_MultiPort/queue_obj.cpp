
/*
 *
 * Created by bill.zhang in 2023;
 *
 */

#include "queue_obj.h"

#include "stdio.h"
#include "stdlib.h"
#include "string.h"




QUEUE_OBJ::QUEUE_OBJ()
{
  q=new QUEUE_OBJ_STRUCT();
}

QUEUE_OBJ::~QUEUE_OBJ()
{
  delete q;
}

void QUEUE_OBJ::InitQueue()
{
  q->lock=1;
  q->queuesize=1024*10;
  q->tail=q->head=0;
  q->lock=0;
}

void QUEUE_OBJ::EmptyQueue()
{
  q->lock=1;
  q->tail=q->head=0;
  q->lock=0;
}

void QUEUE_OBJ::EnQueue(unsigned char data)
{
  q->lock=1;
  unsigned int rear=(q->tail+1)%q->queuesize;
  if(rear==q->head)
  {
    EmptyQueue();
  }
  else
  {
    memcpy(&q->q[q->tail],&data,1);
    q->tail=rear;
  }
}

char QUEUE_OBJ::DeQueue()
{
  char temp;
  if(q->tail==q->head)
  {
    // queue is null;
  }
  else
  {
    temp=q->q[q->head];
    q->q[q->head]=0;
    q->head=(q->head+1)%q->queuesize;
  }
  return temp;
}

unsigned int QUEUE_OBJ::IsQueueEmpty()
{
  if(q->head==q->tail)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

unsigned int QUEUE_OBJ::IsQueueFull()
{
  if((q->tail+1)%q->queuesize==q->head)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

unsigned int QUEUE_OBJ::QueueLength()
{
  return ((q->tail-q->head+q->queuesize)%q->queuesize);
}

unsigned int QUEUE_OBJ::QueueState()
{
  return q->lock;
}





