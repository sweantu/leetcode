from typing import List


class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        i = m + n - 1
        m -= 1
        n -= 1
        while i >= 0:
            num1 = -10e9
            num2 = -10e9      
            if m >= 0:
                num1 = nums1[m]
            if n >= 0:
                num2 = nums2[n]
            if num1 > num2:
                nums1[i] = num1
                m -= 1
            else:
                nums1[i] = num2
                n -= 1
            i -= 1

        
nums1 = [1,2,3,0,0,0]
m = 3
nums2 = [2,5,6]
n = 3
Solution().merge(nums1, m, nums2, n)
print(nums1)
