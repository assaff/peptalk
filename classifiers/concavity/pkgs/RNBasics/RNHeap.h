// Include file for a heap

#ifndef __RN__HEAP__H__
#define __RN__HEAP__H__



// Class definition 

template <class PtrType>
class RNHeap {
  public:
    // Constructor functions
    RNHeap(RNScalar (*value_callback)(PtrType, void *), 
      PtrType **(*entry_callback)(PtrType, void *) = NULL, 
      void *callback_data = NULL, int least_first = TRUE);
    RNHeap(PtrType base, RNScalar *value_ptr, PtrType **entry_ptr = NULL, int least_first = TRUE);
    RNHeap(int value_offset, int entry_offset = -1, int least_first = TRUE);
    ~RNHeap(void); 

    // Data access functions
    int IsEmpty(void) const;
    int NEntries(void) const;
    PtrType Kth(int k) const;
    PtrType operator[](int k) const;
    PtrType Peek(void) const;

    // Manipulation functions
    void Empty(void);
    void Remove(PtrType data);
    void Update(PtrType data);
    void Push(PtrType data);
    PtrType Pop(void);

    // Debug functions
    int IsValid(void);

  protected:
    // Update functions
    int BubbleUp(int i);
    int BubbleDown(int i);
    void Swap(int i, int j);

  private:
    PtrType *entries;
    int nentries;
    int nallocated;
    int value_offset;
    int entry_offset;
    RNScalar (*value_callback)(PtrType, void *);
    PtrType **(*entry_callback)(PtrType, void *);
    void *callback_data;
    int least_first;
};



// Include files

#include "RNHeap.C"



#endif
