<?php

namespace alcamo\xsl;

use PHPUnit\Framework\TestCase;

class ApplyXslCliTest extends TestCase
{
    public function testSimpleRun(): void
    {
        chdir(__DIR__);

        $cli = new ApplyXslCli([]);

        $this->expectOutputString(file_get_contents('bar.foo.expected.xml'));

        $this->assertSame(0, $cli->run('-q -i myfunc.php foo.xsl foo.xml'));
    }

    public function testBatchRun(): void
    {
        chdir(__DIR__);

        if (file_exists('bar.foo.xml')) {
            unlink('bar.foo.xml');
        }

        if (file_exists('bar.foo2.xml')) {
            unlink('bar.foo2.xml');
        }

        $cli = new ApplyXslCli();

        $this->assertSame(
            0,
            $cli->run(
                '-q -i myfunc.php -o bar.%s.xml -s prefix==42= foo.xsl '
                . '../apply_xsl/foo.xml foo2.xml'
            )
        );

        $this->assertSame(
            file_get_contents('bar.foo-with-prefix.expected.xml'),
            file_get_contents('bar.foo.xml')
        );

        $this->assertSame(
            file_get_contents('bar.foo2-with-prefix.expected.xml'),
            file_get_contents('bar.foo2.xml')
        );

        unlink('bar.foo.xml');
        unlink('bar.foo2.xml');
    }
}
