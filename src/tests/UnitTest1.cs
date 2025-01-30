using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MyGithubActionsPresentation.Tests
{
  [TestClass]
  public class UnitTest1
  {
    [TestMethod]
    public void Test1Passes()
    {
      Assert.IsTrue(true);
    }

    [TestMethod]
    public void Test2Passes()
    {
      Assert.IsTrue(true);
    }

    [TestMethod]
    public void Test3Passes()
    {
      Assert.IsTrue(true);
    }

    [TestMethod]
    public void Test4Fails()
    {
      Assert.IsTrue(false);
    }

    [TestMethod]
    public void Test5Fails()
    {
      Assert.IsTrue(false);
    }

    [TestMethod]
    public void Test6Passes()
    {
      Assert.IsTrue(true);
    }
  }
}
