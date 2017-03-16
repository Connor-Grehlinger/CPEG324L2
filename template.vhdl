library library-name-1, library-name-2;
use library-name-1.package-name.all;
use library-name-2.package-name.all;

entity entity_name is

port( input signals : in type;
output signals : out type);
end entity entity_name;

architecture arch_name of entity_name is
-- declare internal signals
-- you may have multiple signals of different types
signal internal-signal-1 : type := initialization;
signal internal-signal-2 : type := initialization;

begin
-- specify value of each signal as a function of other signals
internal-signal-1 <= simple, conditional, or selected CSA;
internal-signal-2 <= simple, conditional, or selected CSA;
output-signal-1 <= simple, conditional, or selected CSA;
output-signal-2 <= simple, conditional, or selected CSA;

end architecture arch_name;