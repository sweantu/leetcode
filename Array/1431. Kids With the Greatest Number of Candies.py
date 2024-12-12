class Solution:
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]:
        # Find the maximum number of candies
        max_candies = max(candies)

        # Create a result list with boolean values based on the condition
        result = [candy + extraCandies >= max_candies for candy in candies]

        return result
