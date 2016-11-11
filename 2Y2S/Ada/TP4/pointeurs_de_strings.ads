with Ada.Unchecked_Deallocation;

package Pointeurs_De_Strings is
	
	type P_String is access String;

	procedure Liberer_String is new Ada.Unchecked_Deallocation(String , P_String);

end Pointeurs_De_Strings;