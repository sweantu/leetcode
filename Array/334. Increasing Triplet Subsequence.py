from typing import List


class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:
        first, second = float("inf"), float("inf")
        for x in nums:
            if x <= first:
                first = x
            elif x <= second:
                second = x
            else:
                return True
        return False


nums = [1, 1, -2, 6]
print(Solution().increasingTriplet(nums=nums))
