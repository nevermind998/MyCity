using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface ILajkoviDAL
    {
        List<Lajkovi> getAllLajkovi();
        void saveLajk(Lajkovi lajk);
        void deleteLajk(List<Lajkovi> lajk);
    }
}
