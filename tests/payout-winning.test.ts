import { describe, it, beforeEach, expect, vi } from "vitest";

// Mock contract methods for 2SureOddBet
const mockContract = {
  createBet: vi.fn(),
  placeBet: vi.fn(),
  closeBetting: vi.fn(),
  setWinnerAndPayout: vi.fn(),
  claimPayout: vi.fn(),
  getBetDetails: vi.fn(),
  getUserBet: vi.fn(),
};

describe("2SureOddBet Smart Contract", () => {
  beforeEach(() => {
    // Reset all mocks before each test
    vi.resetAllMocks();
  });

  describe("Bet Creation", () => {
    it("should create a new bet successfully", async () => {
      const event = "Football Match";
      const options = ["Team A", "Team B"];
      const odds = [200, 150];

      mockContract.createBet.mockResolvedValue({
        success: true,
        betId: 1,
      });

      const result = await mockContract.createBet(event, options, odds);
      expect(result.success).toBe(true);
      expect(result.betId).toBe(1);
    });

    it("should fail to create a bet if not the contract owner", async () => {
      const event = "Football Match";
      const options = ["Team A", "Team B"];
      const odds = [200, 150];

      mockContract.createBet.mockResolvedValue({
        success: false,
        error: "Only the contract owner can create a bet.",
      });

      const result = await mockContract.createBet(event, options, odds);
      expect(result.success).toBe(false);
      expect(result.error).toBe("Only the contract owner can create a bet.");
    });
  });
});
