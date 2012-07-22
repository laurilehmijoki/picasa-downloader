Feature: Picasa downloader

  In order to conveniently download my photos from Google Picasa
  As a geek
  I want to run picasa-downloader and see photo albums appearing on my local disk

  Scenario: Run picasa-downloader without arguments
    When I run `picasa-downloader`
    Then the output should contain:
    """
    Picasa downloader

    usage: picasa-downloader [global options] command [command options]
    """

  Scenario: Try downloading single album with insufficient CLI arguments
    When I run `picasa-downloader album`
    Then the output should contain:
    """
    error: Album name is not specified.
    """
