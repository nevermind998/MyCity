using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IDislajkoviDAL
    {
        List<Dislajkovi> getAllDislajkovi();
        void saveDislajk(Dislajkovi data);
        void deleteDislajk(List<Dislajkovi> dislajk);
        
    }
}
