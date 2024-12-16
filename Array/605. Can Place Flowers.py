from typing import List


class Solution:
    def canPlaceFlowers(self, flowerbed: List[int], n: int) -> bool:
        count = 0  # Count of flowers we can plant
        for i in range(len(flowerbed)):
            # Check if the current plot is empty and the adjacent plots (if any) are also empty
            if (
                flowerbed[i] == 0
                and (i == 0 or flowerbed[i - 1] == 0)
                and (i == len(flowerbed) - 1 or flowerbed[i + 1] == 0)
            ):
                flowerbed[i] = 1  # Plant a flower
                count += 1  # Increment the count
                if count >= n:  # If we've planted enough flowers, return True
                    return True
        return count >= n  # Return True if enough flowers were planted, otherwise False


flowerbed, n = [0, 0, 1, 0, 0], 1
print(Solution().canPlaceFlowers(flowerbed, n))


# Key Changes:
# Simplified Initial Checks: The condition len(flowerbed) - (sum(flowerbed) + n) * 2 < -1 was unnecessary. The loop logic already handles whether it's possible to plant n flowers.
# Count Variable: Added a count variable to keep track of how many flowers have been planted, simplifying the logic to check if the required number of flowers can be planted.
# Adjusted Logic for Edge Cases: Simplified the checks for boundary conditions (i == 0 and i == len(flowerbed) - 1) to handle edge cases cleanly.
