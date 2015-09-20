// Source : https://oj.leetcode.com/problems/insertion-sort-list/
// Author : Wenzheng Li
// Date : 2014-07-19
/**********************************************************************************
*
* Sort a linked list using insertion sort.
*
**********************************************************************************/
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode *insertionSortList(ListNode *head) {
        if(head==0)
        return 0;
        if(head->next==0)
        return head;
        vector<ListNode*> listVec;
        ListNode *iter=head;
        while(iter!=0){
            listVec.push_back(iter);
            iter=iter->next;
        }
        for(int i=1;i<listVec.size();i++){
            for(int j=i-1;j>=0;j--){
                if(listVec[j]->val > listVec[j+1]->val){
                    ListNode *temp=listVec[j];
                    listVec[j]=listVec[j+1];
                    listVec[j+1]=temp;
                }
                else
                break;
            }
        }
        head=listVec[0];
        for(int i=0;i<listVec.size()-1;i++){
            listVec[i]->next=listVec[i+1];
        }
        listVec[listVec.size()-1]->next=0;
        return head;
        ////////////////////////////////////////
        // ListNode *iter=head;
        // while(iter->next != 0){
          
        //     if(head->val > iter->next->val){
        //         ListNode *temp=head;
        //         head=iter->next;
        //         ListNode *temp2=iter->next;
        //         iter->next=iter->next->next;
        //         head->next=temp;
        //     }
            
        //     else{
        //          ListNode *innerIter = head;
        //          bool ch=false;
        //          while(innerIter != iter){
        //              if(innerIter->next->val > iter->next->val){
        //                   ListNode *temp=innerIter;
        //                  innerIter->next=iter->next;
                   
        //                 iter->next=iter->next->next;
        //                  innerIter->next->next=temp->next;
        //                 //iter=iter->next;
        //                 ch=true;
        //                  break;
        //              }
        //              else 
        //              {
        //                 innerIter=innerIter->next;
        //              }
        //          }
        //          if(ch==false && iter->next!=0)
        //          iter=iter->next;
        //     }
        // }
        // return head;
        
    }
};
